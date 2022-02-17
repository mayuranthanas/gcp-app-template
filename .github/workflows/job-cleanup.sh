echo "Cleanup"
rm -rf ./{{cookiecutter.name}}/dev

cookiecutter . --no-input --output-dir ./cookiecutter-temp

find ./ -maxdepth 1 \
! -name '.git' \
! -name '.github' \
! -name 'cloudbuild.yaml' \
! -name 'helm' \
! -name 'spinnaker' \
! -name 'terraform' \
! -name 'src' \
! -name 'Dockerfile' \
! -name 'package.json' \
! -name 'cookiecutter-temp' \
! -name 'unit_test_image' \
! -name '.' \
! -name 'cookiecutter.json' \
! -exec rm -rf {} +

echo "Move files to root"
rsync -r ./cookiecutter-temp/*/ . && \
rm -rf ./cookiecutter-temp/

# No need since the action gets trigger by changes to a yaml file
# mv cookiecutter.json cookiecutter.bak
find ./.github -type f -not -name 'pipeline-update.yaml' -delete

echo "Reinitialize git repository"
git config --global user.email "github-actions[bot]@users.noreply.github.com" && \
git config --global user.name "github-actions[bot]" && \
git checkout --orphan temp-branch && \
git add . && \
git commit -m 'Initial commit' && \
git push origin temp-branch:main -f     
