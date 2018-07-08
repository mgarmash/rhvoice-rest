from flask import Flask, request, send_from_directory, after_this_request
import subprocess, os, urllib, hashlib, re
from tools.preprocessing.text_prepare import text_prepare
from shlex import quote

app = Flask(__name__, static_url_path='')
data_path = "/opt/data"


@app.route('/say')
def say():
    text = re.sub('[\r\n]',' ',text_prepare(urllib.parse.unquote(request.args.get('text'))))
    m = hashlib.md5()
    m.update(text.encode('utf-8'))
    file_name = m.hexdigest()
    file_path = data_path + "/" + file_name
    voice = request.args.get('voice')
    voice = "-p anna" if voice is None else "-p %s" % (voice)
    cmd = "echo %s | RHVoice-test %s -o %s.wav && lame %s.wav %s.mp3" % (quote(text), voice, file_path, file_path, file_path)
    subprocess.call([cmd], shell=True)
    @after_this_request
    def remove_file(response):
        os.remove("%s.wav" % (file_path))
        os.remove("%s.mp3" % (file_path))
        return response
    return send_from_directory(data_path, "%s.wav" % (file_name))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
