unit uTestData;

interface

function JsonItem: string;

implementation

function JsonItem: String;
begin

 Result :=
'{ '+
'    "result": [ '+
'        { '+
'            "itemId": 1, '+
'            "name": "Pizza Marguerita", '+
'            "description": "Mussarela, molho de tomate, manjericão fresco", '+
'            "price": "R$ 35,00", '+
'            "availability": true, '+
'            "highlighted": true, '+
'            "category": "PIZZAS", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 2, '+
'            "name": "Pizza Quatro Queijos", '+
'            "description": "Mussarela, provolone, gorgonzola, parmesão", '+
'            "price": "R$ 40,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PIZZAS", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 3, '+
'            "name": "Pizza Calabresa", '+
'            "description": "Mussarela, calabresa, cebola, azeitonas", '+
'            "price": "R$ 38,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PIZZAS", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 4, '+
'            "name": "Pizza Portuguesa", '+
'            "description": "Mussarela, presunto, ovos, cebola, ervilha, azeitonas", '+
'            "price": "R$ 42,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PIZZAS", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 5, '+
'            "name": "X-Bacon", '+
'            "description": "Carne bovina, queijo, bacon, tomate, cebola, alface, catchup e maionese", '+
'            "price": "R$ 19,50", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "LANCHES", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/d65fe743d309f0d5d8b001d40279f52e_x-bacon.png" '+
'        }, '+
'        { '+
'            "itemId": 6, '+
'            "name": "X-Tudo", '+
'            "description": "Carne bovina, frango, queijo, bacon, ovo, tomate, alface, maionese", '+
'            "price": "R$ 22,00", '+
'            "availability": true, '+
'            "highlighted": true, '+
'            "category": "LANCHES", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 7, '+
'            "name": "Porção de Batata Frita", '+
'            "description": "Batata frita crocante", '+
'            "price": "R$ 25,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/d749d5cbd7aa125ebd06106746347ef9_batata.png" '+
'        }, '+
'        { '+
'            "itemId": 8, '+
'            "name": "Porção de Frango a Passarinho", '+
'            "description": "Pedacinhos de frango fritos", '+
'            "price": "R$ 30,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 9, '+
'            "name": "Porção de Polenta Frita", '+
'            "description": "Polenta frita crocante", '+
'            "price": "R$ 28,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": null '+
'        }, '+
'        { '+
'            "itemId": 10, '+
'            "name": "Porção de Onion Rings", '+
'            "description": "Anéis de cebola empanados e fritos", '+
'            "price": "R$ 22,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": null '+
'        } '+
'    ] '+
'} ';

end;
end.

