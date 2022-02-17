echo "dnsRequest: $dnsRequest"
if [ "$dnsRequest" = "" ]; then
   echo "removing dns files..."
   rm ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}-dns-pb.tf
   rm ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}-dns-pr.tf
else
if [ "$dnsRequest" = "private" ]; then
   echo "keeping private dns file"
   rm ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}-dns-pb.tf
   mv ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}-dns-pr.tf ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}.tf
fi
if [ "$dnsRequest" = "public" ]; then
   echo "keeping public  dns file"
   rm ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}-dns-pr.tf
   mv ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}-dns-pb.tf ./{{cookiecutter.name}}/terraform/{{cookiecutter.application}}.tf
fi
   printf "follow instructions [here](https://developers.telus.com/guides/authenticating-users-in-an-end-user-facing-application?single-page=true) to submit your dns request" >> ./{{cookiecutter.name}}/terraform/README.md
fi