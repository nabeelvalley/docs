[[toc]]

A simple application to use EasyOCR and Flask to create a WebApp that is able to process images and return the relevant text

# Requirements/Dependencies

The application has the following dependencies which should be in a `requirements.txt` file:

`requirements.txt`

```
# This file is used by pip to install required python packages
# Usage: pip install -r requirements.txt

# Flask Framework
flask
easyocr
```

# Application Code

The application configures a `Flask` app with the `EasyOCR` library and a simple HTML form with a file upload:

`app.py`

```py
import os
from flask import Flask, flash, request, redirect, url_for, jsonify
from werkzeug.utils import secure_filename
import easyocr

reader = easyocr.Reader(['en'], True)

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
FILE_DIR = 'files'

app = Flask(__name__)

if not os.path.exists(FILE_DIR):
    os.makedirs(FILE_DIR)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = FILE_DIR + '/' + secure_filename(file.filename)
            file.save(filename)
            parsed = reader.readtext(filename)
            text = '<br/>\n'.join(map(lambda x: x[1], parsed))
            # handle file upload
            return (text)
            
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''
```

# Run the Application

The application can be run with the `flask run` command from the application directory (the directory with the `app.py` file)
