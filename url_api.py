from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
from textblob import TextBlob
import os

app = Flask(__name__)

# Function to extract article text
def extract_article_text(url):
    headers = {
        'User-Agent': 'Mozilla/5.0'
    }
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, 'html.parser')
    paragraphs = soup.find_all('p')
    article_text = ' '.join([p.get_text() for p in paragraphs])
    return article_text.strip()

# POST endpoint
@app.route('/news-sentiment', methods=['POST'])
def analyze_url_sentiment():
    try:
        data = request.get_json()
        url = data.get("url")
        if not url:
            return jsonify({'error': 'Missing URL'}), 400

        text = extract_article_text(url)
        if not text:
            return jsonify({'error': 'No content found in article'}), 400

        blob = TextBlob(text)
        return jsonify({
            'polarity': round(blob.sentiment.polarity, 3),
            'subjectivity': round(blob.sentiment.subjectivity, 3),
            'summary': text[:500]
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Run the app (compatible with Render or local)
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
