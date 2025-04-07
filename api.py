from flask import Flask, request, jsonify
from textblob import TextBlob
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

def get_article_text(url):
    headers = {
        'User-Agent': 'Mozilla/5.0'
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')
    paragraphs = soup.find_all('p')
    article_text = ' '.join([para.get_text() for para in paragraphs])
    return article_text.strip()

@app.route('/news-sentiment', methods=['POST'])
def analyze_url():
    try:
        data = request.get_json()
        url = data.get("url")
        if not url:
            return jsonify({"error": "URL missing"}), 400

        article_text = get_article_text(url)
        if not article_text:
            return jsonify({"error": "No content found"}), 404

        blob = TextBlob(article_text)
        return jsonify({
            "url": url,
            "polarity": round(blob.sentiment.polarity, 3),
            "subjectivity": round(blob.sentiment.subjectivity, 3),
            "preview": article_text[:500]
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
