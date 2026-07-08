/*
 * libFuzzer harness for AESCrypt decrypt path.
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int decrypt_stream(FILE *infp, FILE *outfp, unsigned char *passwd, int passlen);

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    int nullfd;
    unsigned char pass[] = "password";
    int passlen = (int)(sizeof(pass) - 1);
    FILE *infp = NULL;
    FILE *outfp = NULL;
    char *outbuf = NULL;
    size_t outsize = 0;
    size_t input_size;

    if (size == 0)
        return 0;

    nullfd = open("/dev/null", O_RDONLY);
    if (nullfd >= 0)
    {
        dup2(nullfd, STDIN_FILENO);
        close(nullfd);
    }

    input_size = size > 65536 ? 65536 : size;

    infp = fmemopen((void *)data, input_size, "rb");
    if (!infp)
        return 0;

    outfp = open_memstream(&outbuf, &outsize);
    if (!outfp)
    {
        fclose(infp);
        return 0;
    }

    decrypt_stream(infp, outfp, pass, passlen);

    fclose(infp);
    fclose(outfp);
    free(outbuf);
    return 0;
}
