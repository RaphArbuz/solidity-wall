var Wall = artifacts.require("./Wall.sol");

var login = 'Raph';
var url = 'http://www.watzatsong.com';
var content = 'This is a test message';
var pricePerLetterInWei = 1000000000000000; // 10 ^ 15

contract('Wall', function(accounts) {

  it("Subscribe and post", function() {
    var instance;
    var initialValue = parseInt(web3.eth.getBalance(accounts[0]));
    Wall.deployed().then(function(ins) {
        instance = ins;

        var price = (login.length + content.length) * pricePerLetterInWei;
        instance.post(login, url, content, {from: accounts[0], value: price}).then(function(res) {

          instance.getNbPosts.call().then(function(nbPosts) {

            assert.equal(nbPosts, 1, "Raph subscribed");
            instance.getPost.call(0).then(function(res) {

              assert.equal(res[0], login, "Nickname");
              assert.equal(res[1], url, "Url");
              assert.equal(res[2], content, 'Message');
              assert.equal(res[3], accounts[0], 'Sender');

              assert.equal(parseInt(web3.eth.getBalance(accounts[0])) < initialValue - price, true, 'Value back');

            })
          });
        })
    });
  });
});