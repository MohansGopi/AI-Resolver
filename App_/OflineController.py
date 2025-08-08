import joblib

# Load model and vectorizer
clf = joblib.load('./Model/svm_model.pkl')
vectorizer = joblib.load('./Model/tfidf_vectorizer.pkl')

# Example inference



class OffileAI:
    
    def Ofline(self,query):
        new_text = [query]
        new_text_tfidf = vectorizer.transform(new_text)
        prediction = clf.predict(new_text_tfidf)
        return "k" if prediction[0]==1 else "Hello, how can I help you? I can't connect with my server"

        
