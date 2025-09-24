 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title After-Sales Service Management
/// @notice Manages customer service requests, agent responses, and client feedback.
/// @dev Supports multiple agents, request tracking, and ownership transfer.
contract AfterSalesService {
    /// @notice Status of a service request.
    enum Status { Pending, InProgress, Resolved, Closed }

    /// @notice Represents a service request.
    struct Request {
        uint256 id;
        address client;
        string description;
        Status status;
        string agentResponse;
        string clientFeedback;
        uint256 createdAt;
        uint256 updatedAt;
    }

    /// @notice The owner of the contract (can manage agents and ownership).
    address public owner;

    /// @notice Counter for total number of requests created.
    uint256 public requestCount;

    /// @notice Mapping of request ID to service request.
    mapping(uint256 => Request) public requests;

    /// @notice Mapping of client address to list of request IDs.
    mapping(address => uint256[]) public clientRequests;

    /// @notice Mapping of authorized agent addresses.
    mapping(address => bool) public agents;

    /// @notice Emitted when a new request is created.
    event RequestCreated(uint256 id, address indexed client, string description);

    /// @notice Emitted when a request is updated by an agent.
    event RequestUpdated(uint256 id, Status status, string agentResponse);

    /// @notice Emitted when a client adds feedback to a request.
    event ClientFeedbackAdded(uint256 id, string clientFeedback);

    /// @dev Restricts access to the owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Access restricted to owner");
        _;
    }

    /// @dev Restricts access to authorized agents.
    modifier onlyAgent() {
        require(agents[msg.sender], "Access restricted to agents");
        _;
    }

    /// @dev Restricts access to the client of a specific request.
    /// @param _id The request ID.
    modifier onlyClient(uint256 _id) {
        require(requests[_id].client == msg.sender, "Not your request");
        _;
    }

    /// @notice Initializes the contract and assigns deployer as owner and default agent.
    constructor() {
        owner = msg.sender;
        agents[msg.sender] = true; // Owner is an agent by default
    }

    /// @notice Adds a new support agent.
    /// @param _agent The address of the agent.
    function addAgent(address _agent) external onlyOwner {
        agents[_agent] = true;
    }

    /// @notice Creates a new service request.
    /// @param _description Description of the issue.
    function createRequest(string calldata _description) external {
        requests[requestCount] = Request({
            id: requestCount,
            client: msg.sender,
            description: _description,
            status: Status.Pending,
            agentResponse: "",
            clientFeedback: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });

        clientRequests[msg.sender].push(requestCount);

        emit RequestCreated(requestCount, msg.sender, _description);
        requestCount++;
    }

    /// @notice Updates an existing request (by an agent).
    /// @param _id The request ID.
    /// @param _status The new status.
    /// @param _agentResponse The agent's response message.
    function updateRequest(
        uint256 _id,
        Status _status,
        string calldata _agentResponse
    ) external onlyAgent {
        Request storage request = requests[_id];
        request.status = _status;
        request.agentResponse = _agentResponse;
        request.updatedAt = block.timestamp;

        emit RequestUpdated(_id, _status, _agentResponse);
    }

    /// @notice Adds client feedback to a request.
    /// @param _id The request ID.
    /// @param _feedback The client's feedback.
    function addClientFeedback(uint256 _id, string calldata _feedback) external onlyClient(_id) {
        requests[_id].clientFeedback = _feedback;
        requests[_id].updatedAt = block.timestamp;

        emit ClientFeedbackAdded(_id, _feedback);
    }

    /// @notice Lists all request IDs of a client.
    /// @param _client The client's address.
    /// @return Array of request IDs belonging to the client.
    function listClientRequests(address _client) external view returns (uint256[] memory) {
        return clientRequests[_client];
    }

    /// @notice Retrieves full details of a request.
    /// @param _id The request ID.
    /// @return id The request ID.
    /// @return client The client address.
    /// @return description The request description.
    /// @return status The current status.
    /// @return agentResponse The response from the agent.
    /// @return clientFeedback The feedback from the client.
    /// @return createdAt The creation timestamp.
    /// @return updatedAt The last update timestamp.
    function getRequest(uint256 _id) 
        external 
        view 
        returns (
            uint256 id,
            address client,
            string memory description,
            Status status,
            string memory agentResponse,
            string memory clientFeedback,
            uint256 createdAt,
            uint256 updatedAt
        ) 
    {
        Request memory r = requests[_id];
        return (
            r.id,
            r.client,
            r.description,
            r.status,
            r.agentResponse,
            r.clientFeedback,
            r.createdAt,
            r.updatedAt
        );
    }

    /// @notice Transfers contract ownership to a new address.
    /// @param _newOwner The new owner's address.
    function transferOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
}
