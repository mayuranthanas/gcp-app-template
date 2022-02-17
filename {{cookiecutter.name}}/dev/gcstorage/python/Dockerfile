FROM python:3

ADD /src/main.py /

RUN pip3 install google.cloud
RUN pip3 install flask

CMD [ "python3", "./main.py" ]
