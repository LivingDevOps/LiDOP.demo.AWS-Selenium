
var assert = require('chai').assert;
var fs = require('fs');
var webdriver = require('selenium-webdriver');
var By = webdriver.By;
var base = require('./../itestBase');

base.browsers.forEach(function(browser) {

    var driver = new webdriver.Builder().
        usingServer(base.seleniumHub).
        withCapabilities({"browserName": browser}).
        build();

    describe("Demo Tests " + __filename, function(){
        before(function(){
            return driver.get(base.siteToTest);    
        });
    
        after(function(done){ 
            driver.quit();
            done();
        });
            
        it("Test Title on " + browser, function(done){
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title));
            driver.getTitle()
                .then(title => assert.equal("LiDOP", title))
                .then(done);
        });

        it("Test Content on " + browser, function (done) {
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'));
            driver.findElement(By.css('h1'))
                .then(elem => elem.getText() )
                .then(text => assert.equal(text, 'Hello LiDOP!'))
                .then(done);
            });
    });
});    
