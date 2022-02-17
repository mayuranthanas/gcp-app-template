#move terraform files to root
if [ "$programmingLanguage" = 'python' ]; 
then
  sed -i -e "s/{git-repo-name}/$MY_REPONAME/g" ./{{cookiecutter.name}}/dev/$DEV_FOLDER/terraform/cloud-function-py.tf
  mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/terraform"/*-py.tf ./{{cookiecutter.name}}/terraform/
fi
if [ "$programmingLanguage" = 'java' ]; 
then
  sed -i -e "s/{git-repo-name}/$MY_REPONAME/g" ./{{cookiecutter.name}}/dev/$DEV_FOLDER/terraform/cloud-function-java.tf
  mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/terraform"/*-java.tf ./{{cookiecutter.name}}/terraform/
fi
if [ "$programmingLanguage" = 'nodejs' ]; 
then
  sed -i -e "s/{git-repo-name}/$MY_REPONAME/g" ./{{cookiecutter.name}}/dev/$DEV_FOLDER/terraform/cloud-function-js.tf
  mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/terraform"/*-js.tf ./{{cookiecutter.name}}/terraform/
fi


#move the Dockerfile and src folder to root
if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/Dockerfile ]; then
  mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage"/Dockerfile ./{{cookiecutter.name}}/Dockerfile 
fi

mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage"/src/* ./{{cookiecutter.name}}/src/  

if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/package.json ]; then
  mv ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/package.json ./{{cookiecutter.name}}/package.json
fi
if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/pom.xml ]; then
  mv ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/pom.xml ./{{cookiecutter.name}}/pom.xml
fi
if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/requirements.txt ]; then
  mv ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/requirements.txt ./{{cookiecutter.name}}/requirements.txt
fi
