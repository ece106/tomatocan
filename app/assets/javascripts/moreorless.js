  function showPanel (panelIndex, colorCode) {
    var tabButtons=document.querySelectorAll(".tabContainer .buttonContainer button");
    var tabPanels=document.querySelectorAll(".tabContainer .tabPanel");
    tabButtons.forEach(function(node) {
      node.style.backgroundColor="";
      node.style.color="";
    });

    tabButtons[panelIndex].style.backgroundColor="none";
    tabButtons[panelIndex].style.color="none";
    tabPanels.forEach(function(node) {
      node.style.display="none";
    });
    tabPanels[panelIndex].style.display="block";
    tabPanels[panelIndex].style.backgroundColor="white";
  }

  function showPanel2 (panelIndex, colorCode) {
    var tabButtons2=document.querySelectorAll(".tabContainer2 .buttonContainer button");
    var tabPanels2=document.querySelectorAll(".tabContainer2 .tabPanel2");
    tabButtons2.forEach(function(node) {
      node.style.backgroundColor="";
      node.style.color="";
    });

    tabButtons2[panelIndex].style.backgroundColor="none";
    tabButtons2[panelIndex].style.color="none";
    tabPanels2.forEach(function(node) {
      node.style.display="none";
    });
    tabPanels2[panelIndex].style.display="block";
    tabPanels2[panelIndex].style.backgroundColor="white";
  }


        var i=0;
        var k=0;
        var j=0;
      function read(){
        if(!i){
          document.getElementById("more").style.display ="inline";
          document.getElementById("dots").style.display ="none";
          $('#angle').toggleClass('rotate');
          i=1;
        }
        else{
          document.getElementById("more").style.display ="none";
          document.getElementById("dots").style.display ="inline";
          $('#angle').toggleClass('rotate');
          i=0;
        }
      }
      function read1(){
        if(!k){
          document.getElementById("more1").style.display ="inline";
          document.getElementById("dots1").style.display ="none";
          $('#angle1').toggleClass('rotate1');
          k=1;
        }
        else{
          document.getElementById("more1").style.display ="none";
          document.getElementById("dots1").style.display ="inline";
          $('#angle1').toggleClass('rotate1');
          k=0;
        }
      }
      function read2(){
        if(!j){
          document.getElementById("more2").style.display ="inline";
          document.getElementById("dots2").style.display ="none";
          $('#angle2').toggleClass('rotate2');
          j=1;
        }
        else{
          document.getElementById("more2").style.display ="none";
          document.getElementById("dots2").style.display ="inline";
          $('#angle2').toggleClass('rotate2');
          j=0;
        }
      }
      read();
      read1();
      read2();

function monthMoreEvents(button){
  $(button).prev().toggle();
  $(button).siblings('.dots').toggle();
  $(button).find('.total').show();
  if($(button).text()=='More Conversations'){
    $(button).text('Less Conversations');
  } else {
    $(button).text('More Conversations');
  }
}
