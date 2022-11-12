//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ChatApp {
    struct user {
        string name;
        friend[] friendList;
    }

    struct friend {
        address pubkey;
        string name;
    }

    struct message {
        address sender;
        uint256 timestamp;
        string msg;
    }

    struct AllUserStruct {
        string name;
        address accountAddress;
    }

    AllUserStruct[] getAllUsers;

    mapping(address => user) userList;
    mapping(bytes32 => message[]) allMessages;

    function checkUserExists(address pubKey) public view returns (bool) {
        if (bytes(userList[pubKey].name).length > 0) {
            return true;
        } else {
            return false;
        }
    }

    //create account
    //check if already is a user
    function createAccount(string calldata name) external {
        require(checkUserExists(msg.sender) == false, "User already exists");

        require(bytes(name).length > 0, "Username cannot be empty");
        userList[msg.sender].name = name;
        getAllUsers.push(AllUserStruct(name, msg.sender));
    }

    //get username
    function getUsername(address pubKey) external view returns (string memory) {
        require(checkUserExists(pubKey), "Usernot Registered");
        return userList[pubKey].name;
    }

    //add friends
    function addFriend(address friend_key, string calldata name) external {
        //person calling the function has created account or not
        require(checkUserExists(msg.sender), "User has not created account");
        //person being added as a friend has an account or not
        require(checkUserExists(friend_key), "FriendAccount is not registered");
        require(
            msg.sender != friend_key,
            "User cannot add themselves as friend"
        );
        require(
            checkAlreadyFriends(msg.sender, friend_key) == false,
            "These users are already friends"
        );
        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key, msg.sender, userList[msg.sender].name);
    }

    function checkAlreadyFriends(address pubkey1, address pubkey2)
        internal
        view
        returns (bool)
    {
        //always searching the shortest one friendList
        if (
            userList[pubkey1].friendList.length >
            userList[pubkey2].friendList.length
        ) {
            address tmp = pubkey1;
            pubkey1 = pubkey2;
            pubkey2 = tmp;
        }

        for (uint256 i = 0; i < userList[pubkey1].friendList.length; i++) {
            if (userList[pubkey1].friendList[i].pubkey == pubkey2) {
                return true;
            }
        }
        return false;
    }

    function _addFriend(
        address me,
        address friend_key,
        string memory name
    ) internal {
        friend memory newFriend = friend(friend_key, name);
        userList[me].friendList.push(newFriend);
    }

    //get my friend
    function getMyFriendList() external view returns (friend[] memory) {
        return userList[msg.sender].friendList;
    }

    //get chat code
    function _getChatCode(address pubkey1, address pubkey2)
        internal
        pure
        returns (bytes32)
    {
        if (pubkey1 < pubkey2) {
            return keccak256(abi.encodePacked(pubkey1, pubkey2));
        } else return keccak256(abi.encodePacked(pubkey2, pubkey1));
    }

    //send message
    function sendMessage(address friend_key, string calldata _msg) external {
        require(checkUserExists(msg.sender), "You don't have an account");
        require(
            checkUserExists(friend_key),
            "The person you're trying to add as friend has not registered"
        );
        require(
            checkAlreadyFriends(msg.sender, friend_key),
            "You are not friend with this person"
        );

        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        message memory newMsg = message(msg.sender, block.timestamp, _msg);
        allMessages[chatCode].push(newMsg);
        //chat code is unique to that two friends
        //they have a seperate chat room to communicate
    }

    //READ MESSAGE
    function readMessage(address friend_key)
        external
        view
        returns (message[] memory)
    {
        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        return allMessages[chatCode];
        //get all the previous messages between those two users
    }

    function getAllAppUser() public view returns (AllUserStruct[] memory) {
        return getAllUsers;
    }
}
