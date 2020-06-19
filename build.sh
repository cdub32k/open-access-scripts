npm run build --prefix open-access-frontend
mv open-access-frontend/dist/index.html open-access-backend

for file in open-access-frontend/dist/*
do
curl --data "@$file" \
     --include \
     --request PUT \
     --header "AccessKey: 58ea1fae-6172-47cf-9ccbca7facc3-4177-4049" \
  "https://ny.storage.bunnycdn.com/open-access-assets/$(basename $file)"
done;

for asset in open-access-frontend/dist/assets/*
do
curl --data-binary "@$asset" \
     --include \
     --request PUT \
     --header "AccessKey: 58ea1fae-6172-47cf-9ccbca7facc3-4177-4049" \
  "https://ny.storage.bunnycdn.com/open-access-assets/assets/$(basename $asset)"
done;

git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend checkout master 
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend add index.html
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend commit -m "server build"
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend push origin master
