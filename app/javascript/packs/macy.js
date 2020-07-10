import Macy from 'macy';

var macy = Macy({
  container: '#macy-container',
  trueOrder: false,
  waitForImages: true,
  margin: 44,
  columns: 5,
  breakAt: {
    1200: 5,
    940: 2,
    520: 1,
    400: 1,
    296: 1
  }
});