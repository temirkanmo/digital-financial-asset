// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WheatAsset {
    // Структура для хранения информации о пшенице
    struct Wheat {
        uint256 id;         // Уникальный идентификатор пшеницы
        uint256 mass;       // Масса в тоннах
        address owner;      // Владелец пшеницы
        bool forSale;       // Флаг, указывающий, выставлена ли пшеница на продажу
        uint256 price;      // Цена пшеницы
    }

    // События
    event WheatRegistered(uint256 id, uint256 mass, address owner);
    event WheatTransferred(uint256 id, address from, address to);
    event WheatForSale(uint256 id, uint256 price);
    event WheatSold(uint256 id, address from, address to, uint256 price);

    // Хранилище для ячеек пшеницы
    mapping(uint256 => Wheat) public wheats;
    uint256 public wheatCount;

    // Регистрация нового земельного участка
    function registerWheat(uint256 _mass) public {
        wheatCount++;
        wheats[wheatCount] = Wheat(wheatCount, _mass, msg.sender, false, 0);
        emit WheatRegistered(wheatCount, _mass, msg.sender);
    }

    // Передача прав собственности на пшеницу
    function transferWheat(uint256 _wheatId, address _newOwner) public {
        require(wheats[_wheatId].owner == msg.sender, "You are not the owner");
        wheats[_wheatId].owner = _newOwner;
        emit WheatTransferred(_wheatId, msg.sender, _newOwner);
    }

    // Выставление пшеницы на продажу
    function putWheatForSale(uint256 _wheatId, uint256 _price) public {
        require(wheats[_wheatId].owner == msg.sender, "You are not the owner");
        wheats[_wheatId].forSale = true;
        wheats[_wheatId].price = _price;
        emit WheatForSale(_wheatId, _price);
    }

    // Покупка пшеницы
    function buyWheat(uint256 _wheatId) public payable {
        require(wheats[_wheatId].forSale, "Wheat is not for sale");
        require(msg.value >= wheats[_wheatId].price, "Insufficient funds");

        address previousOwner = wheats[_wheatId].owner;
        wheats[_wheatId].owner = msg.sender;
        wheats[_wheatId].forSale = false;

        // Перевод средств предыдущему владельцу с проверкой успеха
        (bool success, ) = previousOwner.call{value: msg.value}("");
        require(success, "Transfer failed");

        emit WheatSold(_wheatId, previousOwner, msg.sender, msg.value);
    }

    // Получение информации о ячейке пшеницы
    function getWheatInfo(uint256 _wheatId) public view returns (
        uint256,
        uint256,
        address,
        bool,
        uint256
    ) {
        Wheat storage wheat = wheats[_wheatId];
        return (wheat.id, wheat.mass, wheat.owner, wheat.forSale, wheat.price);
    }
}
