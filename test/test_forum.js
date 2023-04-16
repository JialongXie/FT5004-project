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

    it('1. Test topup of the forumtoken', async () => {
        let TokentopUp = await forumTokenInstance.topUp(1, {from: accounts[1], value: 1000000000000000000});

        assert.notStrictEqual(
            TokentopUp,
            undefined,
            "Failed to top up token"
        );
    });

    it('2. Test withdraw of the forumtoken', async () => {
        let TokenwithDraw = await forumTokenInstance.withdraw(1);
        assert.notStrictEqual(
            TokenwithDraw,
            undefined,
            "Failed to withdraw token"
        );
    });

    it('3. Test register of forumaccount', async () => {
        let accountRegister = await forumAccountInstance.register('123');
        assert.notStrictEqual(
            accountRegister,
            undefined,
            "Failed to register"
        );
    });

    it('4. Test creation of the discussion', async () => {
        let createDis = await forumInstance.createDiscussion('dis1', 'content', 1);

        assert.notStrictEqual(
            createDis,
            undefined,
            "Failed to create discussion1"
        );
    });

    it('5. Test post answer', async () => {
        let postAns = await forumInstance.postAnswer(0, 'answer1');
        assert.notStrictEqual(
            postAns,
            undefined,
            "Failed to post answer1"
        );
    });

    it('6. Test like answer', async () => {
        let likeAns = await forumInstance.likeAnswer(0, 1);
        assert.notStrictEqual(
            likeAns,
            undefined,
            "Failed to like answer1"
        );
    });
});


//     before(async () => {
//         forumTokenInstance = await ForumToken.deployed();
//         forumAccountInstance = await ForumAccount.deployed();
//         forumInstance = await Forum.deployed();
//     });
//     console.log("Testing Forum Contract");

//     it('4. Test creation of the discussion', async () => {
//         let createDis = await forumInstance.createDiscussion('dis1', 'content', 1);

//         assert.notStrictEqual(
//             createDis,
//             undefined,
//             "Failed to create discussion1"
//         );
//     });

//     it('5. Test post answer', async () => {
//         let postAns = await forumInstance.postAnswer(1, 'answer1');
//         assert.notStrictEqual(
//             postAns,
//             undefined,
//             "Failed to post answer1"
//         );
//     });

//     it('6. Test like answer', async () => {
//         let likeAns = await forumInstance.likeAnswer(2, 1);
//         assert.notStrictEqual(
//             likeAns,
//             undefined,
//             "Failed to like answer1"
//         );
//     });
// });