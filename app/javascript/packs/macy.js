import Macy from 'macy';

var macy = Macy({
  container: '#macy-container',
  trueOrder: false,
  waitForImages: true,
  margin: 44,
  columns: 5,
  breakAt: {
    1200: 5,
    940: 3,
    520: 2,
    400: 1
  }
});