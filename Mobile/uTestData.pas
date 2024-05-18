unit uTestData;

interface

function JsonItem: string;

implementation

function JsonItem: String;
begin

 Result :=

' [ '+
'        { '+
'            "itemId": 1, '+
'            "name": "Marguerita", '+
'            "description": "Mussarela, molho de tomate, manjericão fresco", '+
'            "price": "R$ 35,00", '+
'            "availability": true, '+
'            "highlighted": true, '+
'            "category": "PIZZAS", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/b622e171244bcf011f831b811b7ee35b_marguerita.jpg" '+
'        }, '+
'        { '+
'            "itemId": 2, '+
'            "name": "Quatro Queijos", '+
'            "description": "Mussarela, provolone, gorgonzola, parmesão", '+
'            "price": "R$ 40,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PIZZAS", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/7c0ff8e3772c6048c9641a2036e31a04_qautro-queijos.jpg" '+
'        }, '+
'        { '+
'            "itemId": 3, '+
'            "name": "Calabresa", '+
'            "description": "Mussarela, calabresa, cebola, azeitonas", '+
'            "price": "R$ 38,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PIZZAS", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/db6f8519296a37b1b2ad6faf3ca45d22_calabresa.jpg" '+
'        }, '+
'        { '+
'            "itemId": 4, '+
'            "name": "Portuguesa", '+
'            "description": "Mussarela, presunto, ovos, cebola, ervilha, azeitonas", '+
'            "price": "R$ 42,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PIZZAS", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/54c4a86e4bffa9ce523e8e49a5953c5c_portuguesa.jpg" '+
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
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/365063fa6f3aee98c08261760d66ab80_x-tudo.jpg" '+
'        }, '+
'        { '+
'            "itemId": 7, '+
'            "name": "Batata Frita", '+
'            "description": "Batata frita crocante", '+
'            "price": "R$ 25,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/d749d5cbd7aa125ebd06106746347ef9_batata.png" '+
'        }, '+
'        { '+
'            "itemId": 8, '+
'            "name": "Frango a Passarinho", '+
'            "description": "Pedacinhos de frango fritos", '+
'            "price": "R$ 30,00", '+
'            "availability": true, '+
'            "highlighted": true, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/bdf010211e402af647860a09641a033a_frango-a-passarinho.jpg" '+
'        }, '+
'        { '+
'            "itemId": 9, '+
'            "name": "Polenta Frita", '+
'            "description": "Polenta frita crocante", '+
'            "price": "R$ 28,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/6a65465bdceb4c03f76067c391904370_polenta.jpg" '+
'        }, '+
'        { '+
'            "itemId": 10, '+
'            "name": "Onion Rings", '+
'            "description": "Anéis de cebola empanados e fritos", '+
'            "price": "R$ 22,00", '+
'            "availability": true, '+
'            "highlighted": false, '+
'            "category": "PORÇÕES", '+
'            "imageUrl": "https://parsefiles.back4app.com/YUPE8wtSn5blZ8vtygC13KiKqRaxYgCuLA9xlm35/2687627d818aabebab64f724f682ae99_aneis-de-cebola.jpg" '+
'        } '+
'    ] ';

end;

end.

