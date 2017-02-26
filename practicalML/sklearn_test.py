
# coding: utf-8

# In[20]:

import pandas as pd
import quandl

df = quandl.get('WIKI/GOOGL')

df = df[['Adj. Open','Adj. High','Adj. Low','Adj. Close','Adj. Volume',]]
df['HL_PCT'] = ((df['Adj. High']-df['Adj. Close'])/(df['Adj. Close']))*100.0
df['PCT_change'] = ((df['Adj. Close']-df['Adj. Open' ])/(df['Adj. Open']))*100.0


df = df[['Adj. Close', 'HL_PCT', 'PCT_change','Adj. Volume']]





# In[56]:

import numpy as np
import math
from sklearn import preprocessing, cross_validation , svm
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from matplotlib import style
import pickle


# In[22]:

print(df.head())


# In[8]:

print(len(df))


# In[33]:

df['forecast_col'] = df['Adj. Close']
df.fillna(-99999,inplace=True) 
import math 
forecast_out = int(math.ceil(0.01*len(df)))

df['label'] = df['forecast_col'].shift(-forecast_out) # shifting the coluns negatively . This way each roy label column will be adjusted close 10 days in the future.




# In[34]:

print(len(df))


# In[37]:

X = preprocessing.scale(X) 
X = np.array(df.drop(['label'],1))
X_lately = X[-forecast_out:]
X = X[:-forecast_out]

df.dropna(inplace=True)
y = np.array(df['label'])
#Standardization of datasets is a common requirement for many machine learning estimators implemented in scikit-learn; they might behave badly if the individual features do not more or less look like standard normally distributed data: Gaussian with zero mean and unit variance.

print(len(X),len(y))


# In[58]:

X_train , X_test , y_train , y_test = cross_validation.train_test_split(X,y,test_size=0.2) # shuffle keeping the x and y connected and it outputs for traingin and testing data

clf = LinearRegression()
clf.fit(X_train, y_train)

###########savinng the time of building the model time and again by pickling#############

with open('linearregression.pickle','wb') as f:
    pickle.dump(clf,f)
    
pickle_in = open('linearregression.pickle','rb')
clf = pickle.load(pickle_in)

##############  ##########################################################################
accuracy = clf.score(X_test,y_test)
#print(accuracy)

#clf = svm.SVR(kernel= 'poly')
#clf.fit(X_train, y_train)
#accuracy = clf.score(X_test,y_test)
#print(accuracy)


# In[42]:

forecast_set = clf.predict(X_lately)
print(forecast_set,set,accuracy , forecast_out)


# In[52]:

# Here we get the forecasted stock prices for the next 30 days 

df['Forecast'] = np.nan
last_date = df.iloc[-1].name
last_unix = last_date.timestamp()
one_day = 86400
next_unix = last_unix + one_day


# In[55]:

import datetime
for i in forecast_set:
    next_date = datetime.datetime.fromtimestamp(next_unix)
    next_unix += one_day
    df.loc[next_date] = [np.nan for _ in range(len(df.columns)-1)] + [i]
    
df['Adj. Close'].plot()
df['Forecast'].plot()
plt.legend(loc=4)
plt.xlabel('Date')
plt.ylabel('Price')
plt.show()


# In[ ]:



