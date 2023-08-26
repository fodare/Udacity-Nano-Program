hello:
	echo "This is a test make command"

install pip:
	pip install --upgrade pip

test:
	python3 -m pytest -vv test_hello.py

all:	hello, install, test