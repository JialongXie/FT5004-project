pragma solidity ^0.5.0;
import "./ForumToken.sol";
import "./ForumAccount.sol";

contract Forum {
    uint256 public discussionCount = 0;

    //access ForumToken Contract
    ForumToken FRTContract;
    ForumAccount FRAContract;

    struct discussion {
        uint256 discussionId;
        address creator;
        string title;
        string content;
        uint256 reward;
        uint256 timestamp;
        bool completed;
    }

    struct answer {
        uint256 answerId;
        string content;
        address answerer;
        uint256 likes;
        uint256 dislikes;
        uint256 timestamp;
    }

    constructor(ForumToken FRTAddress, ForumAccount FRAAddress) public {
        FRTContract = FRTAddress;
        FRAContract = FRAAddress;
    }

    // record all discussions
    mapping(uint256 => discussion) public discussions;
    // record all answers for each discussion, e.g: answers[_discussionId] returns a list of answers for the discussion
    mapping(uint256 => mapping (uint256 => answer)) public answers;
    // record number of answers in each discussion (for incremental of answer id)
    mapping(uint256 => uint256) answerSizes; // key = discussion id, value = number of answers in the discussion

    event DiscussionCreated(
        address creator,
        uint256 discussionId,
        string title,
        uint256 reward,
        bool completed
    );

    event DiscussionCompleted(
        uint256 id,
        bool completed
    );

    event AnswerCreated(
        uint256 answerId,
        string content,
        address answerer
    );

    //modifier to ensure a function is callable only by the discussion creator 
    modifier creatorOnly(uint256 _discussionId) {
        require(discussions[_discussionId].creator == msg.sender, "Only poster can do this.");
        _;
    }

    // create a discussion with title, content and reward
    function createDiscussion(string memory _title, string memory _content, uint256 _reward) public {
        discussion memory newDiscussion = discussion(
            discussionCount,
            msg.sender,
            _title,
            _content,
            _reward,
            block.timestamp,
            false
        );
        discussions[discussionCount] = newDiscussion;

        // number of answers posted = 0
        answerSizes[discussionCount] = 0;

        // transfer reward from question creator to this contract
        FRTContract.transferFrom(msg.sender, address(this), _reward);

        emit DiscussionCreated(msg.sender, discussionCount, _title, _reward, false);
        discussionCount++;
    }


    // for creator only: mark a discussion as completed
    function discussionCompleted(uint256 _discussionId, uint256 _answerId) public creatorOnly(_discussionId) {
        // reward the best answerer with forum token
        address recipient = getAnswerer(_discussionId, _answerId);
        FRTContract.transferFrom(address(this), recipient, discussions[_discussionId].reward);

        // mark the discussion as completed
        discussions[_discussionId].completed = true;
        emit DiscussionCompleted(_discussionId, discussions[_discussionId].completed);
    }

    // for answerer: answer the question
    function postAnswer(uint256 _discussionId, string memory _answer) public {
        // check if the discussion is completed
        require(discussions[_discussionId].completed == false, "the discussion is completed.");

        // get answer Id
        uint256 _answerId = answerSizes[_discussionId];

        // post answer
        answer memory new_answer = answer(_answerId, _answer, msg.sender, 0, 0, block.timestamp);
        answers[_discussionId][_answerId] = new_answer;
        emit AnswerCreated(_answerId, _answer, msg.sender);

        // give 2 and 5 reputation points to question poster and answer poster respectively
        FRAContract.addReputationPoints(msg.sender, 5);
        address _accountAddress = discussions[_discussionId].creator;
        FRAContract.addReputationPoints(_accountAddress, 2);

        // increase size
        answerSizes[_discussionId] = answerSizes[_discussionId]++;
    }

    // get the answerer
    function getAnswerer(uint256 _discussionId, uint256 _answerId) public view returns (address) {
        return answers[_discussionId][_answerId].answerer;
    }

    // for all: check the answer post given answer id
    function checkAnswer(uint256 _discussionId, uint256 _answerId) public view returns (string memory, address, uint256) {
        answer memory _answer = answers[_discussionId][_answerId];
        return (_answer.content, _answer.answerer, _answer.timestamp);
    }

    // for all: like the answer
    function likeAnswer(uint256 _discussionId, uint256 _answerId) public {
        answers[_discussionId][_answerId].likes += 1;

        // add 1 reputation point to the answerer if likes are more than dislikes
        if (answers[_discussionId][_answerId].likes > answers[_discussionId][_answerId].dislikes) {
            address _accountAddress = answers[_discussionId][_answerId].answerer;
            FRAContract.addReputationPoints(_accountAddress, 1);
        }
    } 

    // for all: dislike the answer
    function dislikeAnswer(uint256 _discussionId, uint256 _answerId) public {
        answers[_discussionId][_answerId].dislikes += 1;
    } 
}