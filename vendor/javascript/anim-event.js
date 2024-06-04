var n=1e3/60,e=500,
/**
 * @typedef {Object} task
 * @property {Event} event
 * @property {function} listener
 */
/** @type {task[]} */
i=[];var t=window.requestAnimationFrame||window.mozRequestAnimationFrame||window.webkitRequestAnimationFrame||window.msRequestAnimationFrame||function(e){return setTimeout(e,n)},a=window.cancelAnimationFrame||window.mozCancelAnimationFrame||window.webkitCancelAnimationFrame||window.msCancelAnimationFrame||function(n){return clearTimeout(n)};var r,o=Date.now();function step(){var n,u;if(r){a.call(window,r);r=null}i.forEach((function(e){var i;if(i=e.event){e.event=null;e.listener(i);n=true}}));if(n){o=Date.now();u=true}else Date.now()-o<e&&(u=true);u&&(r=t.call(window,step))}function indexOfTasks(n){var e=-1;i.some((function(i,t){if(i.listener===n){e=t;return true}return false}));return e}var u={
/**
   * @param {function} listener - An event listener.
   * @returns {(function|null)} A wrapped event listener.
   */
add:function add(n){var e;if(-1===indexOfTasks(n)){i.push(e={listener:n});return function(n){e.event=n;r||step()}}return null},remove:function remove(n){var e;if((e=indexOfTasks(n))>-1){i.splice(e,1);if(!i.length&&r){a.call(window,r);r=null}}}};export default u;

