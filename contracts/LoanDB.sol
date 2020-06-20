//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

/**
  @title loanDB
  @dev stores all the information
  @author Bhasin Neeraj
 */
contract LoanDB {
    //creating a loan state
    enum LoanState {PENDING, ACTIVE, CLOSED}
    //STRUCTURE
    //storing the debt information
    struct Debt {
        uint256 id;
        address borrower;
        address lender;
        uint256 amount;
        uint256 interest;
        uint8 loanState;
    }
    //MODALS
    /**
    @dev
      1. mapping the debtId to add the debt information
      2. storing debt info with borrower addr
      3. storing debt info with borrower lender
      4. check given address is having debt or no
     */
    mapping(uint256 => Debt) private debtInfo;
    mapping(address => uint256[]) private debtHistory;
    mapping(address => uint256[]) private lendHistory;
    mapping(address => bool) private haveDebt;

    LoanState public state = LoanState.PENDING;
    uint256 debtId;

    constructor() public {}

    /**
      @dev to add the debt info.
    
      @param _borrower address of borrower
      @param _amount amount he want
      @param _interest interest rate
     */
    function addDebt(
        address _borrower,
        uint256 _amount,
        uint256 _interest
    ) external {
        debtInfo[debtId] = Debt(
            debtId,
            _borrower,
            address(0),
            _amount,
            _interest,
            uint8(state)
        );
        debtHistory[_borrower].push(debtId);
        debtId++;
    }

    /**
      @dev called when someone lends the moneya and update the lender
      @param _debtId debt number
      @param _lender address of lender
     */
    function updateLender(uint256 _debtId, address _lender) external {
        debtInfo[debtId].lender = _lender;
        debtInfo[debtId].loanState = uint8(LoanState.ACTIVE);
        lendHistory[_lender].push(_debtId);
    }

    function paidDebt(uint256 _debtId) external {
        debtInfo[_debtId].loanState = uint8(LoanState.CLOSED);
    }

    function setHaveDebt(address _sender, bool _state) external {
        haveDebt[_sender] = _state;
    }

    function checkHaveDebt(address _address) external view returns (bool) {
        return haveDebt[_address];
    }

    function getLenderofDebt(uint256 _debtId) external view returns (address) {
        return debtInfo[_debtId].lender;
    }

    function getBorrowerofDebt(uint256 _debtId)
        external
        view
        returns (address)
    {
        return debtInfo[_debtId].borrower;
    }

    function getAmountofDebt(uint256 _debtId) external view returns (uint256) {
        return debtInfo[_debtId].amount;
    }

    function getInterestofDebt(uint256 _debtId)
        external
        view
        returns (uint256)
    {
        return debtInfo[_debtId].interest;
    }

    function getStateofDebt(uint256 _debtId) external view returns (uint8) {
        return debtInfo[_debtId].loanState;
    }

    function getDebtHistory(address _address)
        external
        view
        returns (uint256[] memory)
    {
        return debtHistory[_address];
    }

    function getLendHistory(address _address)
        external
        view
        returns (uint256[] memory)
    {
        return lendHistory[_address];
    }
}
