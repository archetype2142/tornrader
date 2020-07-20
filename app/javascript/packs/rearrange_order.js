import Sortable from 'sortablejs';

var user = document.getElementById("user_items");
var all = document.getElementById("all_items");
var authenticity_token = getMeta('csrf-token');
var update_prices = document.getElementById("update_prices");

var all_items = new Sortable(all, {
  group: 'shared', // set both lists to same group
  animation: 150
});

var user_items = new Sortable(user, {
  group: 'shared',
  animation: 150,
  onAdd: function (evt) {
    categoryChanged(evt.item.id, evt.target.dataset.user, evt.newIndex, evt.oldIndex, authenticity_token, 'added');
  },
  onRemove: function (evt) {
    categoryChanged(evt.item.id, evt.target.dataset.user, evt.newIndex, evt.oldIndex, authenticity_token, 'removed');
  },
  onUpdate: function (evt) {
    var list = [...evt.to.children].map((el, index) => ({index: index, category_id: el.id}));
    sendRearrangeReq(list, evt.target.dataset.user, authenticity_token);
  }
});

async function sendRearrangeReq(list, userID, token) {
  update_prices.style.display = "block";
  const response = await fetch("http://localhost:3000/user/price_lists_order", {
    method: 'POST',
    mode: 'same-origin',
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': token
    },
    redirect: 'follow',
    referrerPolicy: 'no-referrer',
    body: JSON.stringify({
      'request': 'reorder',
      'userID': userID,
      'list': list
    }) 
  });
  return response.json();
}

function getMeta(metaName) {
  const metas = document.getElementsByTagName('meta');

  for (let i = 0; i < metas.length; i++) {
    if (metas[i].getAttribute('name') === metaName) {
      return metas[i].getAttribute('content');
    }
  }
  return '';
}

async function categoryChanged(categoryID, userID, newPosition, oldPosition, token, type) {
  const response = await fetch("http://localhost:3000/user/price_lists_order", {
    method: 'POST',
    mode: 'same-origin',
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': token
    },
    redirect: 'follow',
    referrerPolicy: 'no-referrer',
    body: JSON.stringify({
      'request': type,
      'userID': userID, 
      'categoryID': categoryID,
      'newPosition': newPosition,
      'oldPosition': oldPosition
    }) 
  });
  return response.json();
}
