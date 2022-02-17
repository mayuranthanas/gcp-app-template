FROM python:3

ADD /src/main.py /

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

CMD [ "python3", "./main.py" ]