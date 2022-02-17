#add newline to base helm files
sed -i '' -e '$a\' ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-*.yaml
#move helm files to repo/helm folder
cat ./{{cookiecutter.name}}/dev/$DEV_FOLDER/helm/{{cookiecutter.application}}-cloudpsql-st.yaml >> ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-st.yaml
cat ./{{cookiecutter.name}}/dev/$DEV_FOLDER/helm/{{cookiecutter.application}}-cloudpsql-pr.yaml >> ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-pr.yaml


#move the Dockerfile and src folder to root
mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage"/Dockerfile ./{{cookiecutter.name}}/Dockerfile 
mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage"/src/* ./{{cookiecutter.name}}/src/  

#move terraform files to root
mv "./{{cookiecutter.name}}/dev/$DEV_FOLDER"/terraform/* ./{{cookiecutter.name}}/terraform/  
            
if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/package.json ]; then
  mv ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/package.json ./{{cookiecutter.name}}/package.json
fi
if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/pom.xml ]; then
  mv ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/pom.xml ./{{cookiecutter.name}}/pom.xml
fi
if [ -f ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/requirements.txt ]; then
  mv ./{{cookiecutter.name}}/dev/$DEV_FOLDER/$programmingLanguage/requirements.txt ./{{cookiecutter.name}}/requirements.txt
fi

