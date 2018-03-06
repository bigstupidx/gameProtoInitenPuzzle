using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour {
    public int Coup1Star;
    public int Coup2Stars;
    public int Coup3Stars;

    public Sprite YellowStar;

    private int coups;

    private GameObject EndMenu;
    private Text NbCoups;
    private Image[] Stars;

    public static LevelManager Instance;

	void Start () {
        Instance = this;
        coups = 0;

        EndMenu = GameObject.Find("EndMenu").gameObject;
        NbCoups = GameObject.Find("NbCoups").GetComponent<Text>();

        Stars = new Image[3];
        Stars[0] = GameObject.Find("Star1").GetComponent<Image>();
        Stars[1] = GameObject.Find("Star2").GetComponent<Image>();
        Stars[2] = GameObject.Find("Star3").GetComponent<Image>();
        EndMenu.SetActive(false);
    }

    public void Win()
    {
        int nbStars = 0;

        if(coups <= Coup3Stars)
        {
            nbStars = 3;
        } else if(coups <= Coup2Stars)
        {
            nbStars = 2;
        } else if(coups <= Coup1Star)
        {
            nbStars = 1;
        }

        for(int i = 0; i<nbStars; i++)
        {
            Stars[i].sprite = YellowStar;
        }

        NbCoups.text = "Coups : " + coups;

        EndMenu.SetActive(true);
    }

    public void AddHit()
    {
        coups++;
    }

    public void Lose()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
}
