
PACKAGE_NAME = mypackage
PACKAGE_FOLDER = $(PACKAGE_NAME)/
TESTS_FOLDER = ./tests/ # all pytest files are here
PDOC_TARGET_FOLDER = ./pdoc_output/ # pdoc html files will be placed here

EXAMPLE_NOTEBOOK_FOLDER = ./examples/ # this is where example notebooks are stored
EXAMPLE_NOTEBOOK_HTML_FOLDER = ./examples_html/ # this is where example notebooks are stored
EXAMPLE_NOTEBOOK_MARKDOWN_FOLDER = ./examples_md/ # this is where example notebooks are stored

# examples
# make install
# make uninstall
# make docs
# make tests
# make build

# make clean (deletes all doc files)
# make test (runs unit tests in tests/ and exports notebooks in examples/ and tries to run them)
# make build (actually builds the python package)
# make deploy (actually builds package)


#################### TO DEPLOY INSTRUCTIONS ###########################
#make test
#make clean
#make docs
#make build
#make deploy


# toplevel (run when enters 'make' without args)
all: docs build
	git add Makefile

final_check: docs build test
	@echo "ran final check"

push_all: 
	git commit -a -m '[auto_pushed_from_Makefile]'
	git push

reinstall:
	pip uninstall -y doctable
	pip install .

uninstall:
	pip uninstall -y doctable

install:
	pip install .


########################################## BUILD AND DEPLOY ################################
build:
	# install latest version of compiler software
	pip install --user --upgrade setuptools wheel
	
	# actually set up package
	python setup.py sdist bdist_wheel
	
	git add setup.cfg setup.py LICENSE
	
clean_build:
	-rm -r build
	-rm -r dist
	-rm -r $(PACKAGE_NAME).egg-info

deploy: build
	# mostly pulled from https://medium.com/@joel.barmettler/how-to-upload-your-python-package-to-pypi-65edc5fe9c56
	#also this: https://packaging.python.org/tutorials/packaging-projects/
	
	# first make sure deploy package is activated
	pip install --user --upgrade twine
	
	# create a source distribution
	python setup.py sdist
	
	# here we go now upload
	python -m twine upload dist/*
	


################################# CREATE DOCUMENTATION ##############################

docs: pdoc example_notebooks
	git add README.md

pdoc:
	pdoc --docformat google -o $(PDOC_TARGET_FOLDER) $(PACKAGE_FOLDER)

example_notebooks:
	jupyter nbconvert --to html $(EXAMPLE_NOTEBOOK_FOLDER)/*.ipynb
	mv $(EXAMPLE_NOTEBOOK_FOLDER)/*.html $(EXAMPLE_NOTEBOOK_HTML_FOLDER)
	git add --all $(EXAMPLE_NOTEBOOK_HTML_FOLDER)*.html

	jupyter nbconvert --to html $(EXAMPLE_NOTEBOOK_FOLDER)/*.ipynb
	mv $(EXAMPLE_NOTEBOOK_FOLDER)/*.html $(EXAMPLE_NOTEBOOK_MARKDOWN_FOLDER)
	
add_docs:
	git add --all $(PDOC_TARGET_FOLDER)*.html
	git add --all $(EXAMPLE_NOTEBOOK_MARKDOWN_FOLDER)*.html

clean_docs:
	-rm $(PDOC_TARGET_FOLDER)*.html
	-rm $(EXAMPLE_NOTEBOOK_HTML_FOLDER)*.html

######################################## RUN TESTS ########################################

pytest: uninstall
	# tests from tests folder
	cd $(TESTS_FOLDER); pytest test_*.py


TMP_TEST_FOLDER = tmp_test_deleteme
test_examples: uninstall
	# make temporary testing folder and copy files into it
	mkdir $(TMP_TEST_FOLDER)
	cp $(EXAMPLE_NOTEBOOK_FOLDER)/*.ipynb $(TMP_TEST_FOLDER)
	-cp $(EXAMPLE_NOTEBOOK_FOLDER)/*.py $(TMP_TEST_FOLDER)
	
	# convert notebooks to .py scripts
	jupyter nbconvert --to script $(TMP_TEST_FOLDER)/*.ipynb
	
	# execute example files to make sure they work

	# THESE NOTEBOOKS WILL BE TESTED
	cd $(TMP_TEST_FOLDER); python ex_basics.py
	


clean_tests:
	# cleanup temp folder
	-rm -r $(TMP_TEST_FOLDER)


test: pytest test_examples clean_tests
tests: test # alias	
	
	
################################ CLEAN ####################################

clean: clean_tests clean_docs clean_build


	
