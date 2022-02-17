echo "checking optional services... DEV_FOLDER: $DEV_FOLDER"
export MERGED_HEML_FILE_ST="./{{cookiecutter.name}}/merged-st.yaml"
export MERGED_HEML_FILE_PR="./{{cookiecutter.name}}/merged-pr.yaml"
echo "#Environment Variables" > $MERGED_HEML_FILE_ST
echo "#Environment Variables" > $MERGED_HEML_FILE_PR

export FS_ST=""
export FS_PR=""
# check the optional pubsub services
if [ "$pubsub_topic" != "" ] && [ "$pubsub_subscription" != "" ];
then
  #add pubsub related helm and terraform to project
  export FS_ST="./{{cookiecutter.name}}/dev/pubsub/helm/{{cookiecutter.application}}-st.yaml"
  export FS_PR="./{{cookiecutter.name}}/dev/pubsub/helm/{{cookiecutter.application}}-pr.yaml"
  mv "./{{cookiecutter.name}}/dev/pubsub"/terraform/* ./{{cookiecutter.name}}/terraform/
fi
# check the optional cloudpsql services
if [ "$cloudpsql_cloudsqlConnNameNp" != "" ] && [ "$cloudpsql_cloudsqlConnNamePr" != "" ];
then
  #add cloudpsql related helm and terraform to project
  export FS_ST="$FS_ST ./{{cookiecutter.name}}/dev/cloudpsql/helm/{{cookiecutter.application}}-st.yaml"
  export FS_PR="$FS_PR ./{{cookiecutter.name}}/dev/cloudpsql/helm/{{cookiecutter.application}}-pr.yaml"
  mv "./{{cookiecutter.name}}/dev/cloudpsql"/terraform/* ./{{cookiecutter.name}}/terraform/ 
fi
# check the optional memstoreRedis services
if [ "$memstoreRedis_redisIP" != "" ] && [ "$memstoreRedis_redisPort" != "" ];
then
  #add memstoreRedis related helm and terraform to project
  export FS_ST="$FS_ST ./{{cookiecutter.name}}/dev/memstoreredis/helm/{{cookiecutter.application}}-st.yaml"
  export FS_PR="$FS_PR ./{{cookiecutter.name}}/dev/memstoreredis/helm/{{cookiecutter.application}}-pr.yaml"
  mv "./{{cookiecutter.name}}/dev/memstoreredis"/terraform/* ./{{cookiecutter.name}}/terraform/
fi
# check the optional gcstorage services
if [ "$gcstorage_storageBucket" != "" ];
then
  #add gcstorage related helm and terraform to project
  export FS_ST="$FS_ST ./{{cookiecutter.name}}/dev/gcstorage/helm/{{cookiecutter.application}}-st.yaml"
  export FS_PR="$FS_PR ./{{cookiecutter.name}}/dev/gcstorage/helm/{{cookiecutter.application}}-pr.yaml"
  mv "./{{cookiecutter.name}}/dev/gcstorage"/terraform/* ./{{cookiecutter.name}}/terraform/
fi
# check the optional firestore services
if [ "$firestore_collectionName" != ""  ];
then
  #add firestore related helm and terraform to project
  export FS_ST="$FS_ST ./{{cookiecutter.name}}/dev/firestore/helm/{{cookiecutter.application}}-st.yaml"
  export FS_PR="$FS_PR ./{{cookiecutter.name}}/dev/firestore/helm/{{cookiecutter.application}}-pr.yaml"
  mv "./{{cookiecutter.name}}/dev/firestore"/terraform/* ./{{cookiecutter.name}}/terraform/
fi

if [ "$FS_ST" != "" ];
then
  echo "Merging helm files..."
  yq ea '. as $item ireduce ({}; . *+ $item )' $FS_ST >> $MERGED_HEML_FILE_ST 
  yq ea '. as $item ireduce ({}; . *+ $item )' $FS_PR >> $MERGED_HEML_FILE_PR 

  echo "removing duplicates..."
  cat -n $MERGED_HEML_FILE_ST | sort -uk2 | sort -nk1 | cut -f2- > t_st.yaml
  cat -n $MERGED_HEML_FILE_PR | sort -uk2 | sort -nk1 | cut -f2- > t_pr.yaml

  #cat t_st.yaml
  #echo "========"
  #cat t_pr.yaml
  #echo "========"
  #add a line at end of the helm files
  sed -i -e '$a\' ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-st.yaml
  sed -i -e '$a\' ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-pr.yaml
  
  #add the merged helm files to the end of the main heml files
  cat t_st.yaml >> ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-st.yaml
  cat t_pr.yaml >> ./{{cookiecutter.name}}/helm/{{cookiecutter.application}}-pr.yaml

  rm -f t_st.yaml
  rm -f t_pr.yaml
fi
rm -f $MERGED_HEML_FILE_ST 
rm -f $MERGED_HEML_FILE_PR 
