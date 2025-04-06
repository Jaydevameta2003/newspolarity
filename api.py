from flask import Flask, request, jsonify
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import nltk
import os

nltk.download('vader_lexicon')
app = Flask(__name__)
analyzer = SentimentIntensityAnalyzer()

@app.route('/api', methods=['GET'])
def analyze_sentiment():
    news_text = request.args.get('Query')
    if not news_text:
        return jsonify({'error': 'Please provide a Query parameter'}), 400

    scores = analyzer.polarity_scores(news_text)
    normalized_score = round((scores['compound'] + 1) / 2, 2)

    if scores['compound'] >= 0.05:
        sentiment = "Positive 😀"
    elif scores['compound'] <= -0.05:
        sentiment = "Negative 😞"
    else:
        sentiment = "Neutral 😐"

    return jsonify({
        'text': news_text,
        'polarity_scores': scores,
        'normalized_score': normalized_score,
        'sentiment': sentiment
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))  # Use PORT from Render or 5000 locally
    app.run(host='0.0.0.0', port=port)
