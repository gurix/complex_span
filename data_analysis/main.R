# Load library
library(rmongodb)

m = mongo.create(host = 'ds039281.mongolab.com:39281', username='heroku_app34171658', password='INSERTPASSWORDHERE', db='heroku_app34171658' )

if(mongo.is.connected(m) == TRUE) {
  mongo.get.database.collections(m, 'heroku_app34171658')

  sessions = mongo.find.all(m, 'heroku_app34171658.sessions')
}
