## [API Docs]

### Core

| API                     |Method| Body        | 설명         |
| ----------------------- |-----|-------------|------------|
| api/books       | GET | -           | 모든 책 가져오기 |
| api/books | POST | -           | 새로운 책  생성하기                      |
| api/books/{id}     | GET | -           | **Rating 서비스** 호출 통한 책 평점 가져오기   |
| api/books/{id}     | PUT | -           | 선택한 책 수정하기                       |
| api/books/{id}     | DELETE | -           | 선택한 책 삭제하기                       |
| api/books/{id}/rating | POST      | float value | **Rating 서비스** 호출 통한 책 평점 업데이트하기 |


### Rating

| API                     |Method|설명                                                   |
| ----------------------- |-----|------------------------------------------------------ |
| api/rating   | GET    | 모든 평점 가져오기    |
| api/rating | POST |새로운 평점  생성하기                                 |
| api/rating/{id} | GET |선택한 평점 가져오기                                 |
| api/rating/{id} | PUT | 선택한 평점 수정하기                  |
| api/rating/{id} | DELETE | 선택된 평점 삭제하기                 |


### Order

| API                     |Method| Body                                    | 설명                                                                             |
| ----------------------- |-----|-----------------------------------------|--------------------------------------------------------------------------------|
| api/orders | GET | -                                       | 모든 주문 가져오기                                                                     |
| api/orders | POST | {"bookId": 3, "quantity": 3, "type": 1} | **`Payment` 서비스** 호출 및 새로운 주문  생성하기 (type: 0 - 구매 / type: 1 - 판매/ type:2 - 렌트) |
| api/orders/{id} | PUT | -                                       | 선택한 주문 수정하기                                                                    |
| api/books/{id}/process | POST | -                                       | **`Payment` 서비스** 에서 결제 완료 후 주문 처리하기 (**`BookInfo` 서비스** 호출 -수량 업데이트)          |

### Payment

| API                     |Method|설명                                                   |
| ----------------------- |-----|------------------------------------------------------ |
| api/payments | GET |모든 결제 요청 가져오기                               |
| api/payments | POST |결제 요청 처리하기 (1~10초 사이 결제 완료된 것으로 처리)                                 |

