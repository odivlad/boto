MAIN_TREE   := HEAD
MAIN_COMMIT := $(shell git rev-parse --verify $(MAIN_TREE))
PKG_NAME    := python-boto
PROG_NAME   := $(shell sed -n s/%define[[:space:]]*pkgname[[:space:]]*//p $(PKG_NAME).spec)
VERSION     := $(shell sed -n s/[[:space:]]*Version:[[:space:]]*//p $(PKG_NAME).spec)

build:
	python setup.py build

install:
	python setup.py install -O1 --skip-build --install-layout=deb --root $(DESTDIR)

distclean:
	python setup.py clean --all
	find -name "*pyc" -delete

clean:
	python setup.py clean --all
	find -name "*pyc" -delete
	rm -rf $(PROG_NAME)-*.tar.gz *.egg *.src.rpm "../$(PROG_NAME)_$(VERSION).orig.tar.gz"

sources:
	@git archive --format=tar --prefix="$(PROG_NAME)-$(VERSION)/" \
		$(MAIN_COMMIT) | gzip > "$(PROG_NAME)-$(VERSION).tar.gz"

sources-deb:
	git archive --format=tar --prefix="$(PROG_NAME)-$(VERSION)/" \
		$(MAIN_COMMIT) | gzip > "../$(PROG_NAME)_$(VERSION).orig.tar.gz"
