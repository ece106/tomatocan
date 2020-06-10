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
  showPanel(0,'#f44336');


      function read(){
        var i=0;
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
        var k=0;

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
        var j=0;
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


