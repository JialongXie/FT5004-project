# FT5004-project
## Objective
#### To create a reward-based forum for public. Users can post their questions on the forum and set reward for the best answer to encourage other users to actively post answers for the question.


## Forum.sol
#### This forum smart contract allows users to create many discussion threads as they want. In each discussion, the discussion creator needs to set question title, quesiton content and reward (in Forum Token). Any other users can participate and post answers within the discussion. The discussion creator reserves the right to choose the best answer and give out the reward to the best answerer. Discussion creator gains reputation points based on the number of answers in the discussion thread. Answer poster gains reputation points based on the number of likes.


## ForumToken.sol
#### The Forum Token is ERC20-based token used for exchange of tokens within the forum. Each Forum Token is equivalent to 0.0001 ether. Users can top up and withdraw Forum Token anytime. The Forum Token withdrawn will flow back to the circulation of the supply.


## ForumAccount.sol
#### This is for reputation points reward system recording. Users can register an account and redeem reputation points to Forum Token (100 reputation points = 1 Forum Token).

## UI
#### The UI is built within the UI folder. Download and click on Index.html to open it
