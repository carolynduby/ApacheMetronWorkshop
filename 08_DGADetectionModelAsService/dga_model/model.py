import sklearn
import numpy as np
import math
import pickle
import collections
class DGA:
  def __init__(self):
    self.model = { 'clf': pickle.loads(open('./dga_model_random_forest.model','rb').read())
                 , 'alexa_vc': pickle.loads(open('./dga_model_alexa_vectorizor.model','rb').read())
                 , 'alexa_counts': pickle.loads(open('./dga_model_alexa_counts.model','rb').read())
                 , 'dict_vc': pickle.loads(open('./dga_model_dict_vectorizor.model','rb').read())
                 , 'dict_counts': pickle.loads(open('./dga_model_dict_counts.model','rb').read()) }

  def evaluate_domain(self, domain):
    alexa_match = self.model['alexa_counts'] * self.model['alexa_vc'].transform([domain]).T
    dict_match = self.model['dict_counts'] * self.model['dict_vc'].transform([domain]).T

    # Assemble feature matrix (for just one domain)
    X = [len(domain), self.entropy(domain), alexa_match, dict_match]
    y_pred = self.model['clf'].predict([ X ])[0]
    return y_pred

  def entropy(self, s):
    p, lns = collections.Counter(s), float(len(s))
    return -sum( count/lns * math.log(count/lns, 2) for count in p.values())