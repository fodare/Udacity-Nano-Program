hello:
	echo "This is a test make command"

install:
	pip install --upgrade pip && pip install -r requirements.txt

lint:
	pylint --disable=R,C,E1120,W0613 SampleClick.py

test:
	python3 -m pytest -vv test_hello.py

all: hello, install, test