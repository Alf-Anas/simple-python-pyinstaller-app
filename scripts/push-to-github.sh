if [ -d "simple-python-pyinstaller-app" ] 
then
    rmdir /Q /S simple-python-pyinstaller-app
else
    echo "Directory don't exist, cloning project..."
fi

git clone -b build https://github.com/Alf-Anas/simple-python-pyinstaller-app.git
cp ${env.BUILD_ID}/sources/dist/add2vals simple-python-pyinstaller-app/build/add2vals
git add .
git commit -m 'Update App'
