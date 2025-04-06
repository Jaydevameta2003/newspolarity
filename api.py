from flask import Flask, request, jsonify
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import nltk

nltk.download('vader_lexicon')
app = Flask(__name__)
analyzer = SentimentIntensityAnalyzer()

@app.route('/api', methods=['GET'])
def analyze_sentiment():
    try:
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
    except Exception as e:
        return jsonify({'error': str(e)}), 500