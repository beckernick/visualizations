# -*- coding: utf-8 -*-
'''
Created on Wed Aug 31 09:36:53 2016

@author: nickbecker
'''

import bs4
import urllib2
from PIL import Image
import numpy as np
from wordcloud import WordCloud
from nltk.corpus import stopwords
import re
import matplotlib.pyplot as plt

data_path = '/users/nickbecker/'

# 2016 to 1993 in reverse order
speech_url_list = ['http://www.presidency.ucsb.edu/ws/index.php?pid=111174', 'http://www.presidency.ucsb.edu/ws/index.php?pid=108031',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=104596',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=102826', 'http://www.presidency.ucsb.edu/ws/index.php?pid=99000',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=88928', 'http://www.presidency.ucsb.edu/ws/index.php?pid=87433',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=85753', 'http://www.presidency.ucsb.edu/ws/index.php?pid=76301',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=24446', 'http://www.presidency.ucsb.edu/ws/index.php?pid=65090',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=58746', 'http://www.presidency.ucsb.edu/ws/index.php?pid=29646',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=29645', 'http://www.presidency.ucsb.edu/ws/index.php?pid=29644',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=29643', 'http://www.presidency.ucsb.edu/ws/index.php?pid=58708',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=57577', 'http://www.presidency.ucsb.edu/ws/index.php?pid=56280',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=53358', 'http://www.presidency.ucsb.edu/ws/index.php?pid=53091',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=51634', 'http://www.presidency.ucsb.edu/ws/index.php?pid=50409',
                'http://www.presidency.ucsb.edu/ws/index.php?pid=47232']


speech_list = []

for url in speech_url_list:
    print url
    response = urllib2.urlopen(url)
    html = response.read()
    soup = bs4.BeautifulSoup(html)
    
    tags = soup.find_all('span')
        
    span_length_list = []
    
    for x in tags:
        span_length_list.append(len(x.text))
        
    speech_index = np.argmax(span_length_list)
    speech_list.append(tags[speech_index].text)


# clean the text
speech_list_lower = map(lambda x: x.lower(), speech_list)
speech_list_clean = map(lambda x: x.encode('utf-8').decode('utf-8').replace('\xe2\x80\x94'.decode('utf-8'), '-'), speech_list_lower)
speech_list_clean = map(lambda x: re.sub('[^a-zA-Z]', ' ', x), speech_list_clean)
speech_list_clean = map(lambda x: ' '.join([y.strip() for y in x.split()]), speech_list_clean)


# Choose the stopwords
stopwords_eng = set(stopwords.words('english'))
stopwords_updated = stopwords_eng | set(['will', 'must', 'can', 'make', 'new', 'need', 'like',
                'sure', 'get', 'still', 'america', 'americans', 'american', 'government', 'every',
                'now', 'year', 'years', 'know', 'one', 'many', 'congress', 'also',
                'shall', 'ask', 'people', 'world', 'nation', 'nations', 'last', 'think',
                'let', 'believe', 'state', 'well', 'want', 'country', 'plan', 'say',
                'national', 'may', 'president', 'federal', 'tonight', 'united', 'states',
                'time', 'act', 'session', 'great', 'meet', 'first', 'today', 'us', 'll', 've',
                're', 'even'])

# read the mask image
eagle_mask = np.array(Image.open(data_path + 'downloads/bald-eagle.jpg'))


year_start = 2016
for i in range(len(speech_list_clean)):
    print year_start - i
    # Make the wordcloud mask
    wc = WordCloud(background_color = 'white', max_words = 500, mask = eagle_mask,
                   stopwords = stopwords_updated).generate(speech_list_clean[i])
    
    # store to file with the year
    path = data_path + 'Python_Projects/wordcloud/sotu_cloud_{0}.png'.format(year_start - i)
    plt.figure(figsize = (10,10))
    plt.title('{0} State of the Union'.format(year_start - i))
    plt.imshow(wc)
    plt.axis("off")
    plt.savefig(path)
    plt.close()



