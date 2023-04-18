const _deploy_contracts = require("../migrations/2_deploy_contracts");
const truffleAssert = require('truffle-assertions');
var assert = require('assert');

var Forum = artifacts.require("../contracts/Forum.sol");
var ForumAccount = artifacts.require("../contracts/ForumAccount.sol");
var ForumToken = artifacts.require("../contracts/ForumToken.sol");

contract('Forum', function(accounts){

    before(async () => {
        forumTokenInstance = await ForumToken.deployed();
        forumAccountInstance = await ForumAccount.deployed();
        forumInstance = await Forum.deployed();
    });
    console.log("Testing Forum Contract");

    it('1. Test topup of the forum token', async () => {
        let TokentopUp = await forumTokenInstance.topUp(1, {from: accounts[1], value: 1000000000000000000});

        assert.notStrictEqual(
            TokentopUp,
            undefined,
            "Failed to top up token"
        );
    });

    it('2. Test withdraw of the forum token', async () => {
        let TokenwithDraw = await forumTokenInstance.withdraw(1);
        assert.notStrictEqual(
            TokenwithDraw,
            undefined,
            "Failed to withdraw token"
        );
    });

    it('3. Test register of forum account', async () => {
        let accountRegister = await forumAccountInstance.register('123', {from: accounts[2]});
        assert.notStrictEqual(
            accountRegister,
            undefined,
            "Failed to register"
        );
    });

    it('4. Test creation of the discussion', async () => {
        let createDis = await forumInstance.createDiscussion('dis1', 'content', 1, {from: accounts[1]});

        assert.notStrictEqual(
            createDis,
            undefined,
            "Failed to create discussion1"
        );
    });

    it('5. Test post answer', async () => {
        let postAns = await forumInstance.postAnswer(0, 'answer1', {from: accounts[2]});
        assert.notStrictEqual(
            postAns,
            undefined,
            "Failed to post answer1"
        );
    });

    it('6. Test like answer', async () => {
        let likeAns = await forumInstance.likeAnswer(0, 0);
        assert.notStrictEqual(
            likeAns,
            undefined,
            "Failed to like answer1"
        );
    });

    it('7. Test add reputation points', async () => {
        let addRP = await forumAccountInstance.addReputationPoints(accounts[1],100);
        assert.notStrictEqual(
            addRP,
            undefined,
            "Failed to add reputation points"
        );
    });

    it('8. Test exchange reputation points', async () => {
        let exchangeRP = await forumAccountInstance.exchangeReputationPoints(100, {from: accounts[1]});
        assert.notStrictEqual(
            exchangeRP,
            undefined,
            "Failed to exchange reputation points"
        );
    });

    it('9. Test discussion completed', async () => {
        let disComplete = await forumInstance.discussionCompleted(0, 0, {from: accounts[1]});
        assert.notStrictEqual(
            disComplete,
            undefined,
            "Failed to complete discussion"
        );
    });
});
