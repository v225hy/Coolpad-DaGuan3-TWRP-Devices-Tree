// Minimal host-side patcher for retained Unisoc vendor_boot SELinux policies.
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sepol/policydb/policydb.h>

static void *read_file(const char *path, size_t *size) {
	FILE *file = fopen(path, "rb");
	if (file == NULL) {
		perror(path);
		return NULL;
	}
	if (fseek(file, 0, SEEK_END) != 0) {
		perror(path);
		fclose(file);
		return NULL;
	}
	long length = ftell(file);
	if (length < 0 || fseek(file, 0, SEEK_SET) != 0) {
		perror(path);
		fclose(file);
		return NULL;
	}
	void *data = malloc((size_t) length);
	if (data == NULL || fread(data, 1, (size_t) length, file) != (size_t) length) {
		fprintf(stderr, "Unable to read %s: %s\n", path, strerror(errno));
		free(data);
		fclose(file);
		return NULL;
	}
	fclose(file);
	*size = (size_t) length;
	return data;
}

static int write_file(const char *path, const void *data, size_t size) {
	FILE *file = fopen(path, "wb");
	if (file == NULL) {
		perror(path);
		return 1;
	}
	int failed = fwrite(data, 1, size, file) != size;
	if (fclose(file) != 0)
		failed = 1;
	if (failed)
		perror(path);
	return failed;
}

int main(int argc, char *argv[]) {
	if (argc < 4) {
		fprintf(stderr, "Usage: %s INPUT_POLICY OUTPUT_POLICY DOMAIN [DOMAIN ...]\n", argv[0]);
		return 2;
	}

	size_t input_size = 0;
	void *input = read_file(argv[1], &input_size);
	if (input == NULL)
		return 1;

	policydb_t policy;
	policydb_init(&policy);
	if (policydb_from_image(NULL, input, input_size, &policy) != 0) {
		fprintf(stderr, "Unable to parse SELinux policy %s\n", argv[1]);
		free(input);
		policydb_destroy(&policy);
		return 1;
	}
	free(input);

	for (int index = 3; index < argc; ++index) {
		type_datum_t *domain = hashtab_search(policy.p_types.table, argv[index]);
		if (domain == NULL) {
			fprintf(stderr, "SELinux domain %s is absent from %s\n", argv[index], argv[1]);
			policydb_destroy(&policy);
			return 1;
		}
		if (ebitmap_set_bit(&policy.permissive_map, domain->s.value - 1, 1) != 0) {
			fprintf(stderr, "Unable to mark SELinux domain %s permissive\n", argv[index]);
			policydb_destroy(&policy);
			return 1;
		}
	}

	void *output = NULL;
	size_t output_size = 0;
	if (policydb_to_image(NULL, &policy, &output, &output_size) != 0) {
		fprintf(stderr, "Unable to serialize patched SELinux policy\n");
		policydb_destroy(&policy);
		return 1;
	}
	int result = write_file(argv[2], output, output_size);
	free(output);
	policydb_destroy(&policy);
	return result;
}