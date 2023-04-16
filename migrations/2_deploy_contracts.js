const Forum = artifacts.require("Forum");
const ForumAccount = artifacts.require("ForumAccount");
const ForumToken = artifacts.require("ForumToken");

module.exports = (deployer, network, account) => {
    deployer.deploy(ForumToken).then(function(){
        return deployer.deploy(ForumAccount,ForumToken.address).then(function(){
                    return deployer.deploy(Forum,ForumToken.address,ForumAccount.address);
        });

    });

    // deployer.deploy(ForumAccount,ForumToken.address).then(function() {
    //     return deployer.deploy(Forum,ForumToken.address,ForumAccount.address);
    // });

};