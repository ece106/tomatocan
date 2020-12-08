$(document).ready(function(){
    if ($('#event_topic')[0][0].value == "Career Support Group") {
        $('#topicDesc p').text("Want to give out career advice? Host a Career Support Group event.");
    }
    $('#event_topic').on('change', function () {
        if ($('#event_topic')[0].value == "Career Support Group") {
            $('#topicDesc p').text("Want to give out career advice? Host a Career Support Group event.");
        }
        else if ($('#event_topic')[0].value == "Job Fair/Networking") {
            $('#topicDesc p').text("Host your next job fair or networking on ThinQ.tv!");
        }
        else if ($('#event_topic')[0].value == "Parents of STEM girls") {
            $('#topicDesc p').text("Discuss with other parents on how to support and uplift girls to be future leaders in STEM!");
        }
        else if ($('#event_topic')[0].value == "Mentor Office Hour") {
            $('#topicDesc p').text("Hold office hours to help your students on ThinQ.tv.");
        }
        else if ($('#event_topic')[0].value == "STEM student hangout") {
            $('#topicDesc p').text("Hang out with other STEM students!");
        }
        else if ($('#event_topic')[0].value == "STEM Organization Meet & Network") {
            $('#topicDesc p').text("Schedule online events for your organization on ThinQ.tv.");
        }
        else if ($('#event_topic')[0].value == "Book Club") {
            $('#topicDesc p').text("Talk about your favorite books or even your own writing with other literature fans on ThinQ.tv");
        }
    });
});
