# install python
merge_files() {
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' $1 $2 > $2.tmp
    mv $2.tmp $2
    rm $2.tmp
}

echo "Installing dependencies..."
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
pip3 install -q --user --upgrade cookiecutter

# adding json validation
pip3 install -q jsonschema

# install yq
wget -q https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64 -O /usr/bin/yq
chmod u+x /usr/bin/yq

# install jq
sudo apt-get install -q jq

# get latest tag if pipeline is missing
# TODO: add latest source code
if [[ -z $PIPELINE_TAG ]]; then 
    PIPELINE_TAG="pipelines-0.1.0"
fi

# echo "TOKEN: $GITHUB_PAT - $GITHUB_TOKEN"

# Clone pipeline repo
if [[ -z $STARTER_KIT ]]; then 
    git clone --depth 1 --branch $PIPELINE_TAG https://$GITHUB_PAT@github.com/telus/$SOURCE_REPO.git
else
    SOURCE_REPO="main"
fi

# Copying the files
mkdir -p /tmp/templating/{{cookiecutter.application}}
cp -r $SOURCE_REPO/doe-artifacts/spinnaker /tmp/templating/{{cookiecutter.application}}
cp -r $SOURCE_REPO/doe-artifacts/helm /tmp/templating/{{cookiecutter.application}}
cp $SOURCE_REPO/doe-artifacts/cloudbuild.yaml /tmp/templating/{{cookiecutter.application}}

# Check if cookiecutter file exists or exit
if [[ -z `find main/ -name cookiecutter.json` ]]; then
    echo "cookiecutter.json file not found"
    exit 1
fi

cat $(find main/ -name cookiecutter.json) >> /tmp/templating/cookiecutter.json

# the lonely double quote below is not an error, the string passed to -F doesn't recognize 
# line jump, it's for formatting only you can append it at the end of the command
echo "run schema validation..."
jsonschema -i /tmp/templating/cookiecutter.json $ACTION_DIR/models/v1.schema -F "ERROR:{error.message}
"
if [ $? -ne 0 ]; then 
    echo "READ ABOVE FOR THE ERRORS..."
    exit 1
fi

# Check for chart version
if [[ `jq -r '.crqImage' < /tmp/templating/cookiecutter.json` != "gcr.io/cio-gke-devops-e4993356/devops/crq-client:0.1.1" ]]; then
	echo 'You need gcr.io/cio-gke-devops-e4993356/devops/crq-client:0.1.1 as your crqImage'
    exit 1
fi

# Get folder name 
FOLDER=$(cat /tmp/templating/cookiecutter.json | jq .application)
FOLDER=$(sed -e 's/^"//'  -e 's/"$//' <<< $FOLDER)
export $FOLDER 

cookiecutter /tmp/templating/. --no-input --output-dir /tmp/templating/cookiecutter-temp
# sleep 10

# echo "Checking generated files"
# tree /tmp/templating

# Check if directory exists
if [[ ! -d main/$OUTPUT_VALUES_PATH ]]; then 
    mkdir -p main/$OUTPUT_VALUES_PATH
fi

if [[ ! -d main/$OUTPUT_SPINNAKER_PATH ]]; then 
    mkdir -p main/$OUTPUT_SPINNAKER_PATH
fi

echo "Moving generated files to specified outputs"
if [[ -z $STARTER_KIT ]]; then

    # check if file exists to merge them
    # checking st values file
    if [ -f main/$OUTPUT_VALUES_PATH/$FOLDER-st.yaml ]; then 
        merge_files /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-st.yaml main/$OUTPUT_VALUES_PATH/$FOLDER-st.yaml 
    else 
        mv /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-st.yaml main/$OUTPUT_VALUES_PATH/
    fi

    # checking pr values file
    if [ -f main/$OUTPUT_VALUES_PATH/$FOLDER-pr.yaml ]; then
        merge_files /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-pr.yaml main/$OUTPUT_VALUES_PATH/$FOLDER-pr.yaml
    else     
        mv /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-pr.yaml main/$OUTPUT_VALUES_PATH/        
    fi

else 
    # merge output from starter kit with our values.yaml file
    merge_files /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-st.yaml main/$OUTPUT_VALUES_PATH/$FOLDER-st.yaml
    merge_files /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-pr.yaml main/$OUTPUT_VALUES_PATH/$FOLDER-pr.yaml

    # remove st-pr pipeline
    rm main/$OUTPUT_SPINNAKER_PATH/bake-deploy-st-pr.json

    # we add action for future reference
    # this is not working at the moment
    # echo "Generating workflow file for starter Kit..."
    # mkdir -p main/.github/workflows
    # mv $SOURCE_REPO/doe-artifacts/pipeline-update.yaml main/.github/workflows
fi

# echo Copying spinnaker pipelines and crq and jira client charts...
mv /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-crq.yaml main/$OUTPUT_VALUES_PATH
mv /tmp/templating/cookiecutter-temp/$FOLDER/helm/$FOLDER-jira.yaml main/$OUTPUT_VALUES_PATH
mv /tmp/templating/cookiecutter-temp/$FOLDER/spinnaker/* main/$OUTPUT_SPINNAKER_PATH

# echo In this point we are overidding the cloudbuild.yaml
mv /tmp/templating/cookiecutter-temp/$FOLDER/cloudbuild.yaml main/

# Get current date
now="$(date +'%Y-%m-%d')"


# echo "This is the repository $REPOSITORY"
# Git push
cd main
if [[ -z $STARTER_KIT ]]; then 
    git config --global user.name "github-actions[bot]"
    git config --global user.email "github-actions[bot]@users.noreply.github.com"
    git checkout -b "$PIPELINE_TAG-$now"
    git add .
    git commit -m "chore: $PIPELINE_TAG generated by github actions"
    git push --set-upstream origin "$PIPELINE_TAG-$now"
else 
    echo "Pushing to repo from starter Kit..."
    rm -rf doe-artifacts
    git config --global user.name "github-actions[bot]"
    git config --global user.email "github-actions[bot]@users.noreply.github.com"
    git checkout --orphan temp-branch 
    git add . 
    git commit -m 'Initial commit' 
    git push origin temp-branch:main -f
fi