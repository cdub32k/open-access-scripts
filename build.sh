npm run build --prefix open-access-frontend
mv open-access-frontend/dist/index.html open-access-backend

BUNNY_CDN_STORAGE_ZONE_PWD=58ea1fae-6172-47cf-9ccbca7facc3-4177-4049

curl --include \
     --request DELETE \
     --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
'https://ny.storage.bunnycdn.com/open-access-dev/app/'

curl --include \
     --request DELETE \
     --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
'https://ny.storage.bunnycdn.com/open-access-dev/assets/'


for file in open-access-frontend/dist/*
do
  if [ ! -d "$file" ]; then
  curl --data "@$file" \
      --include \
      --request PUT \
      --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
    "https://ny.storage.bunnycdn.com/open-access-assets/app/$(basename $file)"
  fi
done;

for asset in open-access-frontend/dist/assets/*
do
curl --data-binary "@$asset" \
     --include \
     --request PUT \
     --header "AccessKey: $BUNNY_CDN_STORAGE_ZONE_PWD" \
  "https://ny.storage.bunnycdn.com/open-access-assets/assets/$(basename $asset)"
done;

git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend checkout master 
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend add index.html
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend commit -m "server build"
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend push origin master
