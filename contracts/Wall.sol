pragma solidity ^0.4.17;

import "./strings.sol";

contract Wall {

    using strings for *;

    uint constant PRICE_PER_LETTER_IN_WEI = 10**14; // about 0.04 euros at March 19th 2018
    address constant UNICEF_ADDRESS = 0x29165d4a5eE555b3B47FA7d4772f35FE41dB2769;

    address public manager; // the one creating the token. Cannot be changed later.

    struct Post {
        string  author;
        string  url;
        string  content;
        address sender;
    }

    Post[] public posts;

    function Wall() public {
        manager = msg.sender;
    }

    event Posted(string author, string url, string content);
    event Transferred(string author, uint amount);

    function getNbPosts() public view returns(uint length) {
        return posts.length;
    }

    function getPost(uint i) public view returns (string  author, string url, string  content, address sender) {
        author = posts[i].author;
        url = posts[i].url;
        content = posts[i].content;
        sender = posts[i].sender;
    }

    /**
     * Adds a post to the wall and transfers the funds to UNICEF
     */
    function post(string author, string url, string content) public payable returns (address) {

        var nbChars = author.toSlice().len() + content.toSlice().len();
        var price = nbChars * PRICE_PER_LETTER_IN_WEI;

        require(msg.value >= price);
        require(nbChars >= 0);
        require(url.toSlice().startsWith("http".toSlice()));

        posts.push(Post(author, url, content, msg.sender));

        Posted(author, url, content);

        UNICEF_ADDRESS.transfer(msg.value);
        Transferred(author, msg.value);

        return msg.sender;
    }

}
