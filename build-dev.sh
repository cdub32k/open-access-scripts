npm run build-dev --prefix open-access-frontend
mv open-access-frontend/dist/index.html open-access-backend

BUNNY_CDN_STORAGE_ZONE_PWD=bbdfe5a1-2853-488b-9857e9d09f58-d2ae-4331

curl --include \
     --request DELETE \
     --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
'https://storage.bunnycdn.com/open-access-dev/app/'

for file in open-access-frontend/dist/*
do
  if [ ! -d "$file" ]; then
  curl --data "@$file" \
      --include \
      --request PUT \
      --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
    "https://storage.bunnycdn.com/open-access-dev/app/$(basename $file)"
  fi
done;

for asset in open-access-frontend/dist/assets/*
do
curl --data-binary "@$asset" \
     --include \
     --request PUT \
     --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
  "https://storage.bunnycdn.com/open-access-dev/app/assets/$(basename $asset)"
done;

git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend checkout dev 
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend add index.html
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend commit -m "server build"
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend push origin dev
