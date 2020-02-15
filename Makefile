
.PHONY: blog
blog:
	cd blog-src; nikola build
	rsync -r blog-src/output/ blog
