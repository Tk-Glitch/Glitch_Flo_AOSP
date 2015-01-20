#include <linux/export.h>
#include <linux/fs.h>
#include <linux/uio.h>
#include <linux/pagemap.h>

struct iov_iter;

unsigned long iov_iter_alignment(const struct iov_iter *i)
{
	const struct iovec *iov = i->iov;
	unsigned long res;
	size_t size = i->count;
	size_t n;

	if (!size)
		return 0;

	res = (unsigned long)iov->iov_base + i->iov_offset;
	n = iov->iov_len - i->iov_offset;
	if (n >= size)
		return res | size;
	size -= n;
	res |= n;
	while (size > (++iov)->iov_len) {
		res |= (unsigned long)iov->iov_base | iov->iov_len;
		size -= iov->iov_len;
	}
	res |= (unsigned long)iov->iov_base | size;
	return res;
}
EXPORT_SYMBOL(iov_iter_alignment);

int iov_iter_npages(const struct iov_iter *i, int maxpages)
{
	size_t offset = i->iov_offset;
	size_t size = i->count;
	const struct iovec *iov = i->iov;
	int npages = 0;
	int n;

	for (n = 0; size && n < i->nr_segs; n++, iov++) {
		unsigned long addr = (unsigned long)iov->iov_base + offset;
		size_t len = iov->iov_len - offset;
		offset = 0;
		if (unlikely(!len))	/* empty segment */
			continue;
		if (len > size)
			len = size;
		npages += (addr + len + PAGE_SIZE - 1) / PAGE_SIZE
			  - addr / PAGE_SIZE;
		if (npages >= maxpages)	/* don't bother going further */
			return maxpages;
		size -= len;
		offset = 0;
	}
	return min(npages, maxpages);
}
EXPORT_SYMBOL(iov_iter_npages);
